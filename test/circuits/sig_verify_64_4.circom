pragma circom 2.0.2;

include "../../circom-ecdsa/circuits/ecdsa.circom";

// sanity testing sig verification in circom
template SigVerify(n, k) {
    assert(k >= 2);
    assert(k <= 100);

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
}

component main = SigVerify(64, 4);