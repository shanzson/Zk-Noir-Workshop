use dep::std;

fn main(x: u1, y: u1)  {
    std::println(x);
    assert(x + y == 500);
}

#[test]
fn test_1() {
    main(100, 400);
}

#[test]
fn test_2() {
    main(100, 200);
}

#[test]
fn test_3() {
    main(1, 5);
}

#[test]
fn test_4() {
    main(5, 2);
}