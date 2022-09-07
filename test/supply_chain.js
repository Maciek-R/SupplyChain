var SupplyChain = artifacts.require("SupplyChain");

contract("SupplyChain", async accounts => {
  it("should create participants", async () => {
    let instance = await SupplyChain.deployed();
    let participantId = await instance.addParticipant("A", "passA", "Manufacturer", "0xEea01CAc2C7861d3C656B5f30934CA353C6f8604");
    let participant = await instance.participants(0);

    assert.equal(participant[0], "A");
    assert.equal(participant[2], "Manufacturer");

    participantId = await instance.addParticipant("C", "passC", "Supplier", "0x830d8B4E250A9ECA103993d681DF997266d50D52");
    participant = await instance.participants(1);

    assert.equal(participant[0], "C");
    assert.equal(participant[2], "Supplier");
  });

  it("should get participants details", async () => {
      let instance = await SupplyChain.deployed();
      let participantA = await instance.getParticipant(0);
      let participantB = await instance.getParticipant(1);

      assert.equal(participantA[0], "A");
      assert.equal(participantB[0], "C");
    });
});
