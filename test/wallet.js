const Wallet = artifacts.require('Wallet');

contract('Wallet', async ([acc1, acc2, acc3, ...remAccts]) => {
    let instance;
    before(async () => {
        instance = await Wallet.new([acc1, acc2, acc3], 2);
    })
    // const instance = Wallet.deployed([acc1, acc2, acc3], 2);
    it('should contain correct length for signers, and count for confirmationQuorum', async () => {
        const signers = await instance.getSigners();
        const confirmationsQuorum = await instance.confirmationsQuorum();
        expect(signers).to.have.lengthOf(3);
        expect(confirmationsQuorum.toNumber()).to.equal(2);
    });

    it('should create transfer and add it to the list', async () => {
        const [to] = remAccts
        console.log(to);
        await instance.createTransfer(1000, to, {from: acc1});
        const transfers = await instance.getTransfers();
        expect(transfers.length).to.equal(1);
    });

    it('should increase approvals count for the specified transfer', async () => {
        await instance.confirmTransfer(0, {from: acc1});
        const transfers = await instance.getTransfers();
        expect(transfers[0].sent).to.equal(false);
        expect(transfers[0].numConfirmations).to.equal('1');
    })
})