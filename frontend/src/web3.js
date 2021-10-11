import Web3 from "web3";
import Wallet from "./contracts/Wallet.json";

export const getWeb3 = async () =>
    new Web3("http://127.0.0.1:9545");

// export const getWeb3 = () =>
//     new Promise((resolve, reject) => {
//         window.addEventListener('load', async () => {
//             if(window.ethereum) {
//                 const web3 = new Web3(window.ethereum)
//                 try {
//                     await window.ethereum.enable();
//                     resolve(web3)
//                 }catch(err) {
//                     reject(err)
//                 }
//             }else if(window.web3) {
//                 resolve(window.web3)
//             }else {
//                 reject(new Error("Found no Ethereum compatable browser"))
//             }
//         })
//     });

export const getWalletContract = async (web3) => {
    const netId = await web3.eth.net.getId();
    const walletDeployedNet = Wallet.networks[netId];
    return new web3.eth.Contract(
        Wallet.abi,
        walletDeployedNet?.address
    );
}
