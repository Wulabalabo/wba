import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from '@mysten/sui.js/transactions';

import wallet from "./dev-wallet.json"

// Import our dev wallet keypair from the wallet file
const keypair = Ed25519Keypair.fromSecretKey(new Uint8Array(wallet));

// Define our WBA SUI Address
const to = "0xcd639240b79c9ca1677418b4c6a49b9503a65d84a3763772f55d59359e981ec2";

const client = new SuiClient({ url: getFullnodeUrl("devnet")});

(async () => {
    try {
        //create Transaction Block.
        const txb = new TransactionBlock();
        //Split coins
        let [coin] = txb.splitCoins(txb.gas, [500000000]);
        //Add a transferObject transaction
        txb.transferObjects([coin, txb.gas],keypair.getPublicKey().toSuiAddress());
        let txid = await client.signAndExecuteTransactionBlock({ signer: keypair, transactionBlock: txb });
        console.log(`Success! Check our your TX here:
        https://suiexplorer.com/txblock/${txid.digest}?network=devnet`);
    } catch(e) {
        console.error(`Oops, something went wrong: ${e}`)
    }
})();

(async () => {
    try {
        //create Transaction Block.
        const txb = new TransactionBlock();
        //Add a transferObject transaction
        txb.transferObjects([txb.gas], to);
        let txid = await client.signAndExecuteTransactionBlock({ signer: keypair, transactionBlock: txb });
        console.log(`Success! Check our your TX here:
        https://suiexplorer.com/txblock/${txid.digest}?network=devnet`);
    } catch(e) {
        console.error(`Oops, something went wrong: ${e}`)
    }
})();