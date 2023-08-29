#!/bin/bash

offer=$1
carol_cln_dir=$2
rpcserver=$3
grace_lnd_dir=$4

invoice=$(lightning-cli --network=regtest --lightning-dir=$carol_cln_dir fetchinvoice $offer | jq -r ".invoice")

# Variables for queryroutes
decoded_invoice=$(lightning-cli --network=regtest --lightning-dir=$carol_cln_dir decode $invoice | jq ".")

introduction_node=$(echo $decoded_invoice | jq -r ".invoice_paths[0].first_node_id")
blinding_point=$(echo $decoded_invoice | jq -r ".invoice_paths[0].blinding")
blinded_node_1=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[0].blinded_node_id")
encrypted_data_1=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[0].encrypted_recipient_data")
blinded_node_2=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[1].blinded_node_id")
encrypted_data_2=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[1].encrypted_recipient_data")
blinded_fee=$(echo $decoded_invoice | jq -r ".invoice_paths[0].payinfo.fee_base_msat")

# Variables for sendtoroute
payment_hash=$(echo $decoded_invoice | jq -r ".invoice_payment_hash")

echo $(lncli --network=regtest --rpcserver=$rpcserver --lnddir=$grace_lnd_dir queryroutes \
    --introduction_node=$introduction_node \
    --blinding_point=$blinding_point \
    --blinded_hops=$blinded_node_1:$encrypted_data_1 \
    --blinded_hops=$blinded_node_2:$encrypted_data_2 \
    --blinded_cltv=30 \
    --amt=1 \
    --blinded_base_fee=$blinded_fee \
    | lncli --network=regtest --rpcserver=$rpcserver --lnddir=$grace_lnd_dir sendtoroute \
    --payment_hash=$payment_hash -)
