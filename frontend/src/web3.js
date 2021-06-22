import Web3 from "web3";
import Wallet from "./contracts/Wallet.json";

export const getWeb3 = () =>
    new Web3("http://127.0.0.1:9545");

export const getWalletContract = async (web3) => {
    const netId = await web3.eth.net.getId();
    const walletDeployedNet = Wallet.networks[netId];
    return new web3.eth.Contract(
        Wallet.abi,
        walletDeployedNet && walletDeployedNet.address
    );
}
