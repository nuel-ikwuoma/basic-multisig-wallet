import React, { useEffect, useState } from "react";
import { getWeb3, getWalletContract } from "./web3";

import Header from "./Header";
import CreateTransfer from "./CreateTransfer";
import ListTransfers from "./ListTransfers";

function App() {
  const [web3, setWeb3] = useState(null);
  const [accts, setAccts] = useState([]);
  const [wallet, setWallet] = useState(null);
  const [signers, setSigners] = useState([]);
  const [numConfirmations, setNumConfirmations] = useState(null);
  const [transfers, setTransfers] = useState([]);

  useEffect(() => {
    async function init() {
      const web3 = await getWeb3();
      const wallet = await getWalletContract(web3);
      const accts = await web3.eth.getAccounts();
      const numConfirmations = await wallet.methods.confirmationsQuorum().call();
      const signers = await wallet.methods.getSigners().call();
      const transfers = await wallet.methods.getTransfers().call();
      setWeb3(web3);
      setAccts(accts);
      setWallet(wallet);
      setSigners(signers);
      setNumConfirmations(numConfirmations);
      setTransfers(transfers);
    }
    init();
  });

  const createTransfer  = async ({amount, to}) => {
    await wallet.createTransfer(amount, to)
            .send({from: accts[0]});
  }

  return (!web3 && !accts.length && !wallet) ?
    <div>Loading...</div> : 
    (
      <div className="App">
        <p>Multisig wallet demo</p>
        <Header signers={signers} quorum={numConfirmations} />
        <CreateTransfer createTransfer={createTransfer} />
        <ListTransfers transfers={transfers} quorum={numConfirmations} />
      </div>
    );
}

export default App;
