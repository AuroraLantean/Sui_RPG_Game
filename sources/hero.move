module package_addr::example {
	use sui::balance::{Self, Balance};
	use sui::coin::{Self, Coin};
	use sui::event;
	use sui::sui::SUI;
	use sui::math;

	public struct Hero has key, store {
			id: UID,
			/// Game this hero is playing in. Should be constant for all players
			game_id: ID,
			/// Hit points. If they go to zero, the hero can't do anything
			health: u64,
			/// Experience of the hero. Begins at zero
			experience: u64,
			/// The hero's minimal inventory
			sword: Option<Sword>,
	}

	public struct Sword has key, store {
			id: UID,
			/// Game this sword is from.
			game_id: ID,
			/// Constant set at creation, used as a multiplier on sword's strength.
			/// Swords with high magic are rarer (because they cost more).
			magic: u64,
			/// Sword grows in strength as we use it
			strength: u64,
	}

	/// For healing wounded heroes
	public struct Potion has key, store {
			id: UID,
			/// Game this potion is from.
			game_id: ID,
			/// Effectiveness of the potion
			potency: u64,
	}

	/// A creature that the hero can slay to level up
	public struct Boar has key, store {
			id: UID,
			/// Game this boar is from.
			game_id: ID,
			/// Hit points before the boar is slain
			health: u64,
			/// Strength of this particular boar
			strength: u64,
	}

	/// Game settings managed by a given `admin`.  Holds payments for player actions for the admin to collect.
	public struct GameInfo has key {
			id: UID,//all items in this game should have the same value as game_id
			//payments: Balance<SUI>,
			admin: address,
	}

	/// Only Admin can add boars and potions, and take payments.
	public struct GameAdmin has key, store {
			id: UID,
			/// ID of the game this admin manages
			game_id: ID,
			/// Total number of boars in this game
			boars_created: u64,
			/// Total number of potions in this game
			potions_created: u64,
	}

	/// Event emitted each time a Hero slays a Boar
	public struct BoarSlainEvent has copy, drop {
			/// Address of the user that slayed the boar
			slayer_address: address,
			/// ID of the now-deceased boar
			boar: ID,
			/// ID of the Hero that slayed the boar
			hero: ID,
			/// ID of the game where event happened
			game_id: ID,
	}

	// === Constants ===
	const MAX_HP: u64 = 1000;
	const MAX_MAGIC: u64 = 10;
	const MIN_SWORD_COST: u64 = 100;

	// === Error Codes ===
	/// Objects are from a different game
	const EWrongGame: u64 = 0;

	const EBOAR_WON: u64 = 0;
	const EHERO_TIRED: u64 = 1;
	const ENOT_ADMIN: u64 = 2;
	const EINSUFFICIENT_FUNDS: u64 = 3;
	const ENO_SWORD: u64 = 4;
	const ASSERT_ERR: u64 = 999;
	
	// --- Initialization

	/// On module publish, sender creates a new game. But once it is published,
	/// anyone create a new game with a `new_game` function.
	fun init(ctx: &mut TxContext) {
			create(ctx);
	}

	/// Anyone can create run their own game, all game objects will be
	/// linked to this game.
	public entry fun new_game(ctx: &mut TxContext) {
			create(ctx);
	}

	/// Create a new game. Separated to bypass public entry vs init requirements.
	fun create(ctx: &mut TxContext) {
			let sender = tx_context::sender(ctx);
			let id = object::new(ctx);
			let game_id = object::uid_to_inner(&id);

			transfer::freeze_object(GameInfo {
					id, admin: sender,
			});
			transfer::transfer(GameAdmin {
							id: object::new(ctx),
							game_id,
							boars_created: 0,
							potions_created: 0,
					},sender);
	}

}