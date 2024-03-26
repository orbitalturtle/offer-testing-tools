Here we set up the following network:

`carol (LND using LNDK) <-> alice (Eclair) <- dave (LND using LNDK) <-> bob (Eclair)`

Where LND1 will pay an offer created by Eclair2.

Most of this we are easily able to set up in Polar, using the above zip file. In Polar, import the above zip using "Import network."

Next:
- You'll need to create a running instance of LNDK that's pointing to Dave. You can find the appropriate connection details (address, macaroon path, and tls cert path) by clicking on Dave, going to "Connect" 
- Create an offer using Eclair2:
	- Right click on `Bob` (Eclair2) and go to "Launch Terminal"
	- Use the command `eclair-cli tipjarshowoffer` to create an offer. 
	- Copy the offer it spits out.
- Pay the offer using `lndk-cli pay-offer` command:
	- You'll need to use this branch: https://github.com/lndk-org/lndk/pull/91 using the instructions within: https://github.com/lndk-org/lndk/pull/91/commits/5c93f51b924510f648ab4d2a18463d5384dd990d

