use std::fs;

fn main() {
    let cont = fs::read_to_string("input").unwrap();
    let lines: Vec<_> = cont.lines().collect();
    println!("Part 1: {}", solve1(&lines));
    println!("Part 2: {}", solve2(&lines));
}

fn solve1<'a>(lines: &'a Vec<&str>) -> i32 {
    lines
        .iter()
        .map(|ln| {
            let mut digits = ln.chars().filter(|x| x.is_digit(10)).peekable();
            let first = digits.peek().unwrap().clone();
            let last = digits.last().unwrap();

            (first.to_digit(10).unwrap() * 10 + last.to_digit(10).unwrap()) as i32
            // * Initially wrote it like this, so I'm keeping it
            // [first.to_owned(), last.to_owned()]
            //     .iter()
            //     .collect::<String>()
            //     .parse::<i32>()
            //     .unwrap()
        })
        .sum()
}

const NUMBERS: [&str; 9] = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
];

fn solve2<'a>(lines: &'a Vec<&str>) -> i32 {
    lines
        .iter()
        .map(|ln| {
            let mut digits = ln.chars().enumerate().filter_map(|(i, c)| {
                if c.is_digit(10) {
                    return c.to_digit(10).map(|x| x as i32);
                }

                NUMBERS
                    .iter()
                    .position(|x| ln[i..].starts_with(x))
                    .map(|x| (x + 1) as i32)
                // * Initially wrote it like this, so I'm keeping it
                // if let Some(idx) = DIGITS.iter().position(|x| ln[i..].starts_with(x)) {
                //     Some((idx + 1) as i32)
                // } else {
                //     None
                // }
            }).peekable();

            digits.peek().unwrap() * 10 + digits.last().unwrap()
        })
        .sum::<i32>()
}
