const path = require("path");
const chai = require("chai");
const circom_tester = require("circom_tester");

const assert = chai.assert;
const wasm_tester = circom_tester.wasm;

// TODO: generate a few from the frontend and put em all here
const sampleInput = {
    "root": "12890874683796057475982638126021753466203617277177808903147539631297044918772",
    "pathElements": [
        "1",
        "217234377348884654691879377518794323857294947151490278790710809376325639809",
        "18624361856574916496058203820366795950790078780687078257641649903530959943449",
        "19831903348221211061287449275113949495274937755341117892716020320428427983768",
        "5101361658164783800162950277964947086522384365207151283079909745362546177817",
        "11552819453851113656956689238827707323483753486799384854128595967739676085386",
        "10483540708739576660440356112223782712680507694971046950485797346645134034053",
        "7389929564247907165221817742923803467566552273918071630442219344496852141897",
        "6373467404037422198696850591961270197948259393735756505350173302460761391561",
        "14340012938942512497418634250250812329499499250184704496617019030530171289909",
        "10566235887680695760439252521824446945750533956882759130656396012316506290852",
        "14058207238811178801861080665931986752520779251556785412233046706263822020051",
        "1841804857146338876502603211473795482567574429038948082406470282797710112230",
        "6068974671277751946941356330314625335924522973707504316217201913831393258319",
        "10344803844228993379415834281058662700959138333457605334309913075063427817480",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1"
    ],
    "pathIndices": [
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1"
    ],
    "r": [
        "4343621220230669059",
        "18327250808238484200",
        "3755886376029024836",
        "15385541165691570987"
    ],
    "s": [
        "15310264094530460262",
        "1621297553241732651",
        "14659779539793693678",
        "6674094315802436376"
    ],
    "msghash": [
        "8013684013107543400",
        "3149366482839937187",
        "3130562494311484551",
        "15702822023081012803"
    ],
    "pubkey": [
        [
            "18367636299713276357",
            "3160037443724067799",
            "17055831292340408725",
            "11407900522529698842"
        ],
        [
            "6013285874336619060",
            "5158666445349947378",
            "11042035041177518474",
            "16013362528823638363"
        ]
    ]
};

// NOTE: not ideal to hardcode this in the future...
const sampleAddress = "1355224352695827483975080807178260403365748530407";

describe("dizkus-data generated inputs", function () {
  this.timeout(1200000);

  it("pubkey to address", async () => {
    let circuit = await wasm_tester(
      path.join(__dirname, "circuits", "pubkey_to_address.circom")
    );
    await circuit.loadConstraints();

    const witness = await circuit.calculateWitness(
      { pubkey: sampleInput.pubkey },
      true
    );
    await circuit.checkConstraints(witness);
    await circuit.assertOut(witness, { address: sampleAddress });
  });

  it("merkle tree inclusion", async () => {
    let circuit = await wasm_tester(
      path.join(__dirname, "circuits", "verify_merkle_proof_30.circom")
    );
    await circuit.loadConstraints();

    const input = {
      root: sampleInput.root,
      pathElements: sampleInput.pathElements,
      pathIndices: sampleInput.pathIndices,
      leaf: sampleAddress,
    };
    const witness = await circuit.calculateWitness(input, true);
    await circuit.checkConstraints(witness);
  });

  it("sig verification", async () => {
    let circuit = await wasm_tester(
      path.join(__dirname, "circuits", "sig_verify_64_4.circom")
    );
    await circuit.loadConstraints();

    const input = {
      r: sampleInput.r,
      s: sampleInput.s,
      msghash: sampleInput.msghash,
      pubkey: sampleInput.pubkey,
    };
    const witness = await circuit.calculateWitness(input, true);
    await circuit.checkConstraints(witness);
  });

  it("full circuit", async () => {
    let circuit = await wasm_tester(
      path.join(
        __dirname,
        "../scripts",
        "dizkus_64_4_30.circom"
      )
    );
    await circuit.loadConstraints();

    const witness = await circuit.calculateWitness(sampleInput, true);
    await circuit.checkConstraints(witness);
  });
});
