### Sending a blinded payment from LND to CLN

After making a test network in "Steps to Test - CLN" outlined in [this pr](https://github.com/lightningnetwork/lnd/pull/7267), users can use the `lnd-sendtoroute` script to automate making a full blinded payment.

With this network set up, we can use the `lnd-sendtoroute` script to automate generating a route with lnd and then sending a payment.

There's just a couple of steps:
- First you'll need `Dave` to generate an offer.
- Then you should be able to execute the script with the following arguments to automatically find a full route to the offer, and send the payment:

```
./lnd-sendtoroute.sh <LNOFFER> <CAROL'S_LIGHTNINGD_DIR> <GRACE'S RPC_ENDPOINT> <GRACES_LNDDIR>
```
