### Test LNDK pay-offer on a hybrid network

To test `lndk-cli pay-offer` in [this PR](https://github.com/lndk-org/lndk/pull/91), we use a network of four nodes.

`carol (LND using LNDK) <-> dave (CLN) <-> frank (CLN) <-> georgia (LDK via ldk-sample)`

For now, this test is unsuccessful. The second CLN node (which is chosen as the introduction node) responds with a InvalidOnionPayload error - using a debugger shows CLN is unable to decrypt the blinded route payload for whatever reason: https://github.com/ElementsProject/lightning/blob/master/common/onion_decode.c#L259

This might have been fixed with https://github.com/lightningdevkit/rust-lightning/pull/2936. We will need to revisit and test this once LDK v122 is out and ldk-sample has been updated with the fix as well.

In Polar, spin up `lnd-cln.polar.zip`. You don't necessarily need to know all this, but here are some of the things we set in the Polar network:
- A base regtest Bitcoind node
- An lnd node (Carol)
        - A custom version that is able to send payments across a blinded route and sign a tagged hash
        - Also is running with the needed `protocol` config flags, set in Advanced Options in Polar
- A CLN node (Dave)
        - With the experimental-offers config flag set in Advanced Options

Unfortunately we can't spin up some of the other nodes in Polar because they aren't supported yet or it isn't easy to do what we need.

So we have a number of other steps to do:
- Spin up Frank:
        - We spin this up outside of Polar because creating a custom image with the logs we wanted for debugging this was a pain in the ass.
- Spin up the final node: Georgia, the [LDK/ldk-sample](https://github.com/lightningdevkit/ldk-sample) node that is able to create offers:
        - `cargo run polaruser:polarpass@127.0.0.1:18443 ldk1 19778 regtest`
- Set up three channels going from Frank to Dave. (We set up the channels in this direction because we can't connect in the other direction because Dave is running in Docker and can't connect to Dave, but Frank *can* can connect to Dave.)
        - We need these channels open because LDK doesn't allow using an intro node that has less than three channels.
        - Push money from Frank to Dave has some incoming liquidity.
        - `lightning-cli --network=regtest fundchannel <NODE_ID> <AMOUNT> --push_msat=<AMOUNT>`
- Set up a channel from Frank to Georgia.
- Use ldk-sample to create an offer `getoffer 1000`

Then we can finally attempt to pay the offer with [lndk-cli](https://github.com/lndk-org/lndk/pull/91). Lndk-cli needs to be pointed at Carol, using the credentials Polar specifies when you click on Carol then clicking Connect on the left:

```
cargo run --bin=lndk-cli -- --network=regtest --tls-cert=<CERT_PATH> --macaroon=<MACAROON_PATH> --address=<ADDRESS> pay-offer <OFFER> <AMOUNT>
```
