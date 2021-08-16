const WalletFactory = artifacts.require('WalletFactory');

contract('WalletFactory', async([bob, joe, jil, ..._]) => {
    
    it("should create wallet and increment wallet count", () => {
        WalletFactory.new()
            .then(instance => instance.nextWalletID())
            // .then(instance => {
            //     instance.createWallet([bob, jil], 2)
            // })
            .then(walletCount => {
                console.log(walletCount.valueOf)
                expect(true).to.be(false)
            })

    });

    // it("should return the wallet address owned by the caller", () => {

    // })
})