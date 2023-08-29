This repository houses a couple little tools with the aim of testing CLN-LND route blinding interoperability.

### Script

After making a test network in "Steps to Test - CLN" outlined in [this pr](https://github.com/lightningnetwork/lnd/pull/7267), users can use the `lnd-sendtoroute` script to automate making a full blinded payment.

With this network set up, we can use the `lnd-sendtoroute` script to automate generating a route with lnd and then sending a payment.

There's just a couple of steps:
- First you'll need `Dave` to generate an offer.
- Then you should be able to execute the script with the following arguments to automatically find a full route to the offer, and send the payment:

```
./lnd-sendtoroute.sh <LNOFFER> <CAROL'S_LIGHTNINGD_DIR> <GRACE'S RPC_ENDPOINT> <GRACES_LNDDIR>
```

### WIP: Setup a polar network

These tools aim to make the "Steps to Test - CLN" outlined in [this pr](https://github.com/lightningnetwork/lnd/pull/7267) a bit easier to manage.

The `blinded-routes.polar.zip` can be used in Polar, a tool for quickly setting up Lightning Network test networks, to quickly set up a regtest network specifically for testing interoperability.

This .zip holds one LND node and three CLN nodes connected together by channels, as specified in the instructions in the linked PR above. The LND node is an image at the needed version. The CLN nodes all are running the experimental flags needed to 

To use this .zip:
* Open Polar and click "import network" in the upper right corner.
* Load the zip into Polar.
* Click the network and click "start" to get the network running.

Note: One problem with this setup right now is [this bug](https://github.com/jamaljsr/polar/issues/747). Even though the channels are set up in the test network, when the network is first booted up or restarted, the connections to each CLN peer might be disrupted. You might need to reestablish connections between each node with `lightning-cli connect`. The trick here because of this bug is that you don't want to "localhost" as the "connect" options seem to suggest. You'll want to use `lightning-cli getinfo` to get the correct address. It'll look something like `172.26.0.4`. (I can write out more detailed instructions if anyone would find this helpful.)

### Contact

I'm happy to help or answer any questions. Report an issue or shoot me an email.
