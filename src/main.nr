use dep::std;

global RATE_IN_PERCENT = 5;

struct Item {
    price: Field,
    quantity: Field,
    cost: Field,
}

impl Item {
    fn check_cost(self) -> bool {
        self.price * self.quantity == self.cost
    }
}

fn main(items: [Item; 2]) -> pub Field {
    assert(items.all(|i: Item| i.check_cost())); 
    
    let total = items.fold(0, |x, i: Item| x + i.cost);
    println(total);

    total + (total * RATE_IN_PERCENT) / 100 // 9 + (9 * 5) * inv(100)
}

#[test]
fn test_main() {
    let item1 = Item { price: 1, quantity: 1, cost: 1 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    
    let total = main([item1, item2]);
    println(total);
    // assert(total == 18967536818011759742494742649109346476339598193270847513121495473105084380374 );
}
