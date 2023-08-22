This repository houses a couple little tools with the aim of testing CLN-LND route blinding interoperability.

### Polar network .zip

These tools aim to make the "Steps to Test - CLN" outlined in [this pr](https://github.com/lightningnetwork/lnd/pull/7267) a bit easier to manage.

The `blinded-routes.polar.zip` can be used in Polar, a tool for quickly setting up Lightning Network test networks, to quickly set up a test network specifically for testing interoperability.

This .zip holds one LND node and three CLN nodes connected together by channels, as specified in the instructions in the linked PR above.

To use this .zip:
* Open Polar and click "import network" in the upper right corner.
* Load the zip into Polar.
* Click the network and click "start" to get the network running.

Note: One problem with this setup right now is [this bug](https://github.com/jamaljsr/polar/issues/747). Even though the channels are set up in the test network, when the network is first booted up or restarted, the connections to each CLN peer might be disrupted. You might need to reestablish connections between each node with `lightning-cli connect`. The trick here because of this bug is that you don't want to "localhost" as the "connect" options seem to suggest. You'll want to use `lightning-cli getinfo` to get the correct address. It'll look something like `172.26.0.4`. (I can write out more detailed instructions if anyone would find this helpful.)

### Contact

I'm happy to help or answer any questions. Report an issue or shoot me an email.
