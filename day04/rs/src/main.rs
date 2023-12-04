use std::cmp;
use std::fs;

fn main() {
    let cont = fs::read_to_string("input").expect("File not found");
    let lines = cont.lines().collect::<Vec<_>>();
    let data = parse(lines);
    println!("Part 1: {}", part1(&data));
    println!("Part 2: {}", part2(&data, usize::MAX));
}

fn part1(data: &Vec<(Vec<i32>, Vec<i32>)>) -> i32 {
    data.iter()
        .map(|(winning, mine)| {
            let matching = get_matching_count(winning, mine);
            if matching == 0 {
                0
            } else {
                1 << (matching - 1)
            }
        })
        .sum()
}

fn part2(data: &[(Vec<i32>, Vec<i32>)], limit: usize) -> i32 {
    let mut total = 0;
    for data_idx in 0..cmp::min(data.len(), limit) {
        let (winning, mine) = &data[data_idx];
        let matching = get_matching_count(winning, mine);

        total += 1 + part2(&data[data_idx + 1..], matching);
    }

    total
}

fn get_matching_count(winning: &Vec<i32>, mine: &Vec<i32>) -> usize {
    mine.iter().filter(|x| winning.contains(x)).count()
}

fn parse(lines: Vec<&str>) -> Vec<(Vec<i32>, Vec<i32>)> {
    let lines = lines.iter().map(|ln| ln.split(":").last().unwrap().trim());
    lines
        .map(|ln| {
            let things = ln
                .split("|")
                .map(|part| {
                    let part = part.trim();
                    part.split_whitespace()
                        .map(|x| {
                            let num = x.parse::<i32>().unwrap();
                            num
                        })
                        .collect::<Vec<_>>()
                })
                .collect::<Vec<_>>();
            (things[0].to_owned(), things[1].to_owned())
        })
        .collect()
}
