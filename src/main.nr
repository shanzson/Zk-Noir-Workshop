use dep::std;

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
    assert(items.all(|i: Item| i.check_cost())); // asserting that all elements in items return boolean true
    
    let mut total = 0;
    for item in items {
        total += item.cost;
    }
    
    total
}

#[test]
fn test_main() {
    let item1 = Item { price: 2, quantity: 1, cost: 2 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    
    let total = main([item1, item2]);
    assert(total == 10);
}