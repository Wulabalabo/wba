module frog_bank::bank {
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::dynamic_field as df;
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    struct Bank has key {
        id: UID
    }

    struct OwnerCap has key ,store{
        id: UID
    }

    struct UserBalance has copy, drop, store {user: address}
    struct AdminBalance has copy, drop, store {}

    const FEE: u128 = 5;

    entry fun init(ctx: &mut TxContext){
        let bank = Bank{ id: object::new(ctx) };
        //create a dynamic field with an admin balance of 0
        df::add(&mut bank.id, AdminBalance{}, balance::zero<SUI>());
        //sharing the bank object
        transfer:: share_object(bank);
        //transfer the ownership of the bank to the admin
        transfer::transfer(
            OwnerCap{ id: object::new(ctx) },
            tx_context::sender(ctx));
    }

    public fun deposit(self: &mut Bank, token: Coin<SUI>, ctx: &mut TxContext) {
        let value = coin::value(&token);
        let deposit_value = value - (((value as u128) * FEE / 100) as u64);
        let admin_fee = value - deposit_value;

        let admin_benefit_coin = coin::split(
            &mut token, admin_fee,ctx);

        let admin_balance = df::borrow_mut<AdminBalance, Balance<SUI>>(
            &mut self.id, AdminBalance{});    
    
        balance::join(admin_balance, coin::into_balance(admin_benefit_coin));


        let sender = tx_context::sender(ctx);

        if(df::exists_(&self.id,UserBalance{user:sender})){
            let user_balance = df::borrow_mut<UserBalance, Balance<SUI>>(
                &mut self.id, 
                UserBalance{user:sender});
            balance::join(
                user_balance, 
                coin::into_balance(token));
        }else{
            df::add(
                &mut self.id, 
                UserBalance{user:sender}, 
                coin::into_balance(token));
        }

        
    }

    // public fun withdraw(self: &mut Bank, ctx: &mut TxContext): Coin<SUI> {
        
    // }

    // public fun claim(_: &OwnerCap, self: &mut Bank, ctx: &mut TxContext): Coin<SUI> {
        
    // }

}