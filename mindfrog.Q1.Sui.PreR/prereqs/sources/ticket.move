module prereqs::ticket {
    use sui::transfer;
    use sui::sui::SUI;
    use sui::coin::{Self,Coin};
    use sui::object::{Self,UID};
    use sui::balance::{Self,Balance};
    use sui::tx_context::{Self,TxContext};
    use std::string;
    use sui::url::{Self,Url};

    const ENotEnough: u64 = 0;

    struct TicketOwnerCap has key {id: UID}
    
    struct TICKET_OTW has key {id: UID}

    struct Ticket_Info<T: store> has key, store{
        id: UID,
        contents: T
    }

    struct TicketNFT<T: store> has key,store {
        id: UID,
        name: string::String,
        description: string::String,
        url:Url,
        contents:Ticket_Info<T>
    }

    public fun getContents<T:store>(c: &TicketNFT<T>): &T {
        &c.contents.contents
    }

    fun init(ctx: &mut TxContext){
        //TODO
    }
}