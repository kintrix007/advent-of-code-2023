use std::fs;

fn main() {
    let cont: Vec<Vec<i32>> = fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|ln| {
            let useful = ln.split(":").last().unwrap();
            useful
                .trim()
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect()
        })
        .collect();
    let cont: Vec<_> = cont[0].iter().zip(cont[1].iter()).collect();

    // println!("{:?}", cont);
    println!("Part 1: {}", part1(cont));
}

fn part1(data: Vec<(&i32, &i32)>) -> i32 {
    data.iter()
        .map(|(time, dist)| {
            (0..**time)
                .map(|hold| (**time - hold) * hold)
                .filter(|x| x > *dist)
                .count() as i32
        })
        .product()
}
