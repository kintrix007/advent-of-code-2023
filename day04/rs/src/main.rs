use std::fs;

type Data = Vec<(Vec<i32>, Vec<i32>)>;

fn main() {
    let cont = fs::read_to_string("input").expect("File not found");
    let lines = cont.lines().collect::<Vec<_>>();
    let data = parse(lines);
    println!("Part 1: {}", part1(&data));
}

fn part1(data: &Data) -> i32 {
    data.iter()
        .map(|(winning, mine)| {
            let matching = mine.iter().filter(|x| winning.contains(x)).count() as i32;
            if matching == 0 {
                0
            } else {
                1 << (matching - 1)
            }
        })
        .sum()
}

fn parse(lines: Vec<&str>) -> Data {
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
