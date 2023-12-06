use std::fs;

fn main() {
    let cont = fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|ln| {
            let useful = ln
                .split(":")
                .last()
                .unwrap()
                .chars()
                .filter(|x| x.is_digit(10))
                .collect::<String>();
            useful.parse::<i64>().unwrap()
        })
        .collect::<Vec<_>>();
    let cont = (cont[0], cont[1]);

    // println!("Part 1: {}", part1(cont));
    println!("Part 2: {}", part2(cont));
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

fn part2((time, dist): (i64, i64)) -> i32 {
    (0..time)
        .map(|hold| (time - hold) * hold)
        .filter(|x| *x > dist)
        .count() as i32
}
