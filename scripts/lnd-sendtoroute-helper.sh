#!/bin/sh

invoice=$(lightning-cli --network=regtest fetchinvoice $1 | jq -r ".invoice")

# lno1qgsqvgnwgcg35z6ee2h3yczraddm72xrfua9uve2rlrm9deu7xyfzrcgqgp7szsyw3jhxaqkyypg2s3h4k3qrymhc044cfp6wnntdqcrkc84lk98fl97zvp5qzv8wtc

#echo $invoice

decoded_invoice=$(lightning-cli --network=regtest decode $invoice | jq ".")
introduction_node=$(echo $decoded_invoice | jq -r ".invoice_paths[0].first_node_id")
blinding_point=$(echo $decoded_invoice | jq -r ".invoice_paths[0].blinding")
blinded_node_1=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[0].blinded_node_id")
encrypted_data_1=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[0].encrypted_recipient_data")
blinded_node_2=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[1].blinded_node_id")
encrypted_data_2=$(echo $decoded_invoice | jq -r ".invoice_paths[0].path[1].encrypted_recipient_data")
payment_hash=$(echo $decoded_invoice | jq -r ".invoice_payment_hash")

cd /home/orbital/Code/lightning/lnd

#echo $decoded_invoice | jq "."
#
#echo $(./lncli-debug --network=regtest queryroutes \
#    --introduction_node=$introduction_node \
#    --blinding_point=$blinding_point \
#    --blinded_hops=$blinded_node_1:$encrypted_data_1 \
#    --blinded_hops=$blinded_node_2:$encrypted_data_2 \
#    --blinded_cltv=6 --amt=1) | jq "."

echo $payment_hash

echo $(./lncli-debug --network=regtest queryroutes \
    --introduction_node=$introduction_node \
    --blinding_point=$blinding_point \
    --blinded_hops=$blinded_node_1:$encrypted_data_1 \
    --blinded_hops=$blinded_node_2:$encrypted_data_2 \
    --blinded_cltv=30 --amt=1 --blinded_base_fee=1) | jq "."

#    | ./lncli-debug --network=regtest sendtoroute \
#    --payment_hash=$payment_hash -) | jq "."
