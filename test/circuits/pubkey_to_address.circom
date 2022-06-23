pragma circom 2.0.2;

include "../../circom-ecdsa/circuits/zk-identity/eth.circom";

// NOTE: one day this will be its own circuit for unit testing
template ChunkedPubkeyToAddress() {
    signal input pubkey[2][4];
    signal output address;

    signal pubkeyBits[512];

    component flattenPubkey = FlattenPubkey(64, 4);
    for (var i = 0; i < 4; i++) {
        flattenPubkey.chunkedPubkey[0][i] <== pubkey[0][i];
        flattenPubkey.chunkedPubkey[1][i] <== pubkey[1][i];
    }
    for (var i = 0; i < 512; i++) {
        pubkeyBits[i] <== flattenPubkey.pubkeyBits[i];
    }
    component pubkeyToAddress = PubkeyToAddress();
    for (var i = 0; i < 512; i++) {
        pubkeyToAddress.pubkeyBits[i] <== pubkeyBits[i];
    }
    address <== pubkeyToAddress.address;
}

component main = ChunkedPubkeyToAddress();