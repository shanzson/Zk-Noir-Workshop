# Noir Language
- The Noir syntax assert can be interpreted as something similar to constraints in other zk-contract languages.
- [Noir docs](https://noir-lang.org/docs)
- [Zk Camp's Noir Course](https://github.com/ZKCamp/aztec-noir-course)

## Program 1: Field
- The integer values it takes corresponds to the Elliptic curve used in the backed i.e. the BN254 or BabyJubJub curve.

```
use dep::std;

fn main(price: Field, quantity: Field, cost: Field) {
    assert(price * quantity == cost);
}

#[test]
fn test_main() {
    main(1, 2, 2);
}

```

## Program 2: Tuple

```
use dep::std;

fn main(item: (Field, Field, Field)) {
    assert(item.0 * item.1 == item.2);
}

#[test]
fn test_main() {
    main((1, 2, 2));
}

```

## Program 3: For Loop

```
use dep::std;

fn main(price: [Field; 2], quantity: [Field; 2], cost: [Field; 2]) {
    for i in 0..2 {
        assert(price[i] * quantity[i] == cost[i]);
    }
}

#[test]
fn test_main() {
    let price = [1, 2];
    let quantity = [2, 4];
    let cost = [2, 8];
    main(price, quantity, cost);
}

```

## Program 4: Structs
```

use dep::std;

struct Item {
    price: Field,
    quantity: Field,
    cost: Field,
}

fn main(items: [Item; 2]) {
    for i in 0..2 {
        assert(items[i].price * items[i].quantity == items[i].cost);
    }
}

#[test]
fn test_main() {
    let item1 = Item { price: 1, quantity: 1, cost: 1 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    main([item1, item2]);
}


```

## Program 5: Function

```

use dep::std;

struct Item {
    price: Field,
    quantity: Field,
    cost: Field,
}

impl Item {
    fn check_cost(&self) -> bool {
        self.price * self.quantity == self.cost
    }
}

fn main(items: [Item; 2]) {
    for i in 0..2 {
        assert(items[i].check_cost());
    }
}

#[test]
fn test_main() {
    let item1 = Item { price: 1, quantity: 1, cost: 1 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    main([item1, item2]);
}


```

## Program 6: Declaring with array with elements initialzed
```
let cost = [0 ; 32]; // declares array of size 32 with 0 as its elements
```

## Program 7: Declare array with specific Type
```
let cost : [Field; 32] = [0 ; 32]; 

```

## Program 8: Lambda Function

```
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
    let item1 = Item { price: 1, quantity: 1, cost: 1 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    
    let total = main([item1, item2]);
    assert(total == 9);
}

```

## Programs 9: Division of Fields via Multiplicative inverse (Field takes values only on Baby Jub jub curve)

1) Example 1

```
use dep::std;

fn main(x : Field, y : Field) -> pub Field {
    x / y
}

#[test]
fn test_main() {
    let ans = main(1234232342, 22342943);
    std::println(ans);
    assert(ans == 9845909870436744000122342863999518746684380602622659454731824785756920571868); // check in python
}

```

- `In python:`
- `Value of p below comes from here:` [Baby Jub Jub Docs](https://iden3-docs.readthedocs.io/en/latest/iden3_repos/research/publications/zkproof-standards-workshop-2/baby-jubjub/baby-jubjub.html) 
- Right now Noir uses Grumpkin curve (which is also used in Halo and Mina Protocol)
- Use `int("0x15c4966681608f388da622fe6509f596096c7e7d5155b4585c9d9952165967dc",16)` to convert printed Noir logs into integer in Python

```
>>> a = 1234232342
>>> b = 22342943
>>> a /b
552.4036570741822
>>> p = 17 // Just an example
>>> pow(b, p-2, p)
4
>>> p = 218882428718392752222464057452572750885483644004160343436982041865758084956177 // This prime number we get based on the curve
>>> pow(b, p-2, p)
91512828543817085926892052635269718802102174802145777591539585411032559652298
>>> c = pow(b, p-2, p)
>>> (a * c)%p // mod keeps the values in the range of 0 to p - 1 which is how Fields work here and take values here
164717329083161896680590157042897276647326364647901561062891025479999311136489
>>> int("0x246aaba228fa3a7c159f4466b93f9c7808b0cb92f8ba30919a62d389067679e9", 16)
164717329083161896680590157042897276647326364647901561062891025479999311136489

```


2) 

```
use dep::std;

fn main(x : Field, y : Field) -> pub Field {
    x / y
}

#[test]
fn test_main() {
    let ans = main(1234232342, 22342943);
    std::println(ans);
}
```

- Then run the following command
```
nargo test --show-output
```

- This is another example

```
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
    // assert(total == 3283236430775891283336960861788591263282254660062405151554730627986371274352);
}

```

## Program 10: 
- Run `nargo info` on the above code.
- Then run `nargo info` on the code below and compare
```
use dep::std;

global RATE_IN_PERCENT = 5;
global MIN_TAX_THRESHOLD = 8;

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

    if (total as u64 > MIN_TAX_THRESHOLD){
        total + total * RATE_IN_PERCENT / 100
    }
    else {
        total
    }
}

#[test]
fn test_main() {
    let item1 = Item { price: 1, quantity: 1, cost: 1 };
    let item2 = Item { price: 2, quantity: 4, cost: 8 };
    
    let total = main([item1, item2]);
    println(total);
    // assert(total == 18967536818011759742494742649109346476339598193270847513121495473105084380374 );
}

```



## Go to NodeGuardians Hello World (And Go back in Time: Noir Version 0.22.0)

- Install previous version

```
noirup -v 0.22.0
```

- Provde values to the Prover.toml. 

```
key = "?"
lock_1 = "187"
lock_2 = "459"
```

-  Then run the prove command to generate Prover.toml

```
nargo prove
```
 
-  Note that the Verifier.toml would be empty too. Now run

```
nargo verify
```

- Create a Solidity Verifier contract using

```
nargo codegen-verifier
```

- Note to add 0x before the proof that you give to the verify() function. Copy the Verifier.toml outputs and provide it 
as bytes array to the 2nd parameter of the function.

```
["0x00000000000000000000000000000000000000000000000000000000000000bb", "0x00000000000000000000000000000000000000000000000000000000000001cb"]
```


# Array of structs
The code provided is written in the Noir programming language. Noir is a domain-specific language designed for writing privacy-preserving applications, particularly zero-knowledge proofs (ZKPs).

Here's a breakdown of the code and its functionality:

### Code Breakdown

```rust
// main.nr

struct Foo {
    bar: Field,
    baz: Field,
}

fn main(foos: [Foo; 3]) -> pub Field {
    foos[2].bar + foos[2].baz
}
```

### Explanation

1. **Struct Definition**:
   ```rust
   struct Foo {
       bar: Field,
       baz: Field,
   }
   ```
   - This defines a structure named `Foo` with two fields: `bar` and `baz`.
   - Both fields are of type `Field`. In Noir, `Field` typically represents a field element in a finite field, which is a common datatype in cryptographic applications.

2. **Main Function**:
   ```rust
   fn main(foos: [Foo; 3]) -> pub Field {
       foos[2].bar + foos[2].baz
   }
   ```
   - This is the main function of the Noir program.
   - The function takes an array `foos` of type `[Foo; 3]` as its input. This means `foos` is an array consisting of three `Foo` structs.
   - The function returns a value of type `Field`, and the `pub` keyword makes this return value public, meaning it can be accessed outside the scope of this function.
   - Inside the function, `foos[2]` accesses the third element of the `foos` array (arrays are zero-indexed in most programming languages).
   - The expression `foos[2].bar + foos[2].baz` adds the `bar` and `baz` fields of the third `Foo` struct in the `foos` array and returns the result.

### Example Usage

Suppose you have an array of `Foo` structs:
```rust
let foo1 = Foo { bar: 1, baz: 2 };
let foo2 = Foo { bar: 3, baz: 4 };
let foo3 = Foo { bar: 5, baz: 6 };

let foos = [foo1, foo2, foo3];
```

When you call `main(foos)`, it will perform the following:
- Access the third element `foo3` in the array `foos`.
- Retrieve the `bar` and `baz` fields from `foo3`, which are `5` and `6`, respectively.
- Add these fields: `5 + 6`.
- Return the result `11`.

### Summary

This Noir program defines a simple structure `Foo` with two fields, then implements a function that takes an array of these structures, accesses the third element, and returns the sum of its two fields. This type of computation is useful in scenarios where you need to prove knowledge of some computation without revealing the underlying data, leveraging the properties of zero-knowledge proofs.

## Integers

- The Noir frontend supports both unsigned and signed integer types. The allowed sizes are 1, 8, 16, 32 and 64 bits.
Note: When an integer is defined in Noir without a specific type, it will default to Field.

The one exception is for loop indices which default to u64 since comparisons on Fields are not possible.
- The built-in structure U128 allows you to use 128-bit unsigned integers almost like a native integer type. However, there are some differences to keep in mind:

You cannot cast between a native integer and U128
There is a higher performance cost when using U128, compared to a native type. 

## Strings
- You can use strings in assert() functions or print them with println(). See more about Logging.
- You can convert a str<N> to a byte array by calling as_bytes() or a vector by calling as_bytes_vec().

## Proving Agnostic Noir
The power of the language is that it is proving system agnostic. Once converted into a suitable constraint system, Noir programs can be plugged into a myriad of proving backends.

## Testing in NodeGuardians Quest
- quest set-framework foundry
- Download the quest via `quest find```.
- Old Docs: https://github.com/noir-lang/noir/tree/v0.22.0/docs 

## Awesome Noir
- https://github.com/noir-lang/awesome-noir 


