pragma circom 2.0.2;

include "../circom-ecdsa/circuits/ecdsa.circom";
include "../circom-ecdsa/circuits/zk-identity/eth.circom";
include "./merkle.circom";

/*
    This circuit allows a user to prove membership in a group and 
    anonymously post a message. They input their public key, a signature
    of the message they post, and a merkle tree membership proof in the
    group they're looking to post to.

    Steps
    0) before circuit, verify pubkey is valid
    1) verify signature of message with public key
    2) get address associated with public key
    3) verify address is in group with merkle tree proof

    Inputs 
    - merkle proof (depth d)
        - root
        - branch
        - branch side
    - signature verification (encoded with k registers of n bits each)
        - signature (r, s)
        - msghash
        - pubkey
*/
template Dizkus(n, k, d) {
    assert(k >= 2);
    assert(k <= 100);

    signal input root;
    signal input pathElements[d];
    signal input pathIndices[d];

    signal input r[k];
    signal input s[k];
    signal input msghash[k];
    signal input pubkey[2][k];

    // Step 1: signature verification
    component verifySignature = ECDSAVerifyNoPubkeyCheck(n, k);
    for (var i = 0; i < k; i++) {
        verifySignature.r[i] <== r[i];
        verifySignature.s[i] <== s[i];
        verifySignature.msghash[i] <== msghash[i];
        for (var j = 0; j < 2; j++) {
            verifySignature.pubkey[j][i] <== pubkey[j][i];
        }
    }
    verifySignature.result === 1;

    // Step 2: get address associated with public key
    // adapted from https://github.com/jefflau/zk-identity
    signal pubkeyBits[512];
    signal address;
    component flattenPubkey = FlattenPubkey(n, k);
    for (var i = 0; i < k; i++) {
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

    // Step 3: verify address is in group with merkle tree proof
    component verifyMerkleProof = MerkleTreeChecker(d);
    verifyMerkleProof.leaf <== address;
    verifyMerkleProof.root <== root;
    for (var i = 0; i < d; i++) {
        verifyMerkleProof.pathElements[i] <== pathElements[i];
        verifyMerkleProof.pathIndices[i] <== pathIndices[i];
    }
}