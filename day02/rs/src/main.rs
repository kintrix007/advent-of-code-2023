use std::fs;

#[derive(Debug)]
struct CubeSet {
    red: u32,
    green: u32,
    blue: u32,
}

const LIMIT: CubeSet = CubeSet {
    red: 12,
    green: 13,
    blue: 14,
};

fn main() {
    let cont = fs::read_to_string("input").expect("File not found");
    let lines: Vec<_> = cont.lines().collect();
    let games = parse_games(&lines);
    println!("Part 1: {}", solve1(&games));
}

fn solve1(games: &Vec<Vec<CubeSet>>) -> usize {
    games
        .iter()
        .enumerate()
        .map(|(i, x)| (i, get_max_cubes(x)))
        .filter(|(_, x)| is_valid(x))
        .map(|(i, _)| i + 1)
        .sum()
}

fn is_valid(cube_set: &CubeSet) -> bool {
    return cube_set.red <= LIMIT.red
        && cube_set.blue <= LIMIT.blue
        && cube_set.green <= LIMIT.green;
}

fn get_max_cubes(game: &Vec<CubeSet>) -> CubeSet {
    let mut max = CubeSet {
        red: 0,
        green: 0,
        blue: 0,
    };

    for set in game {
        max.red = std::cmp::max(max.red, set.red);
        max.green = std::cmp::max(max.green, set.green);
        max.blue = std::cmp::max(max.blue, set.blue);
    }

    max
}

fn parse_games<'a>(lines: &Vec<&'a str>) -> Vec<Vec<CubeSet>> {
    lines
        .iter()
        .map(|ln| {
            let useful_cont = ln.split(":").last().expect("Invalid format");
            let useful_cont = useful_cont.trim();
            let sets = useful_cont.split(";").map(|x| x.trim());

            sets.map(|set| {
                let mut cube_set = CubeSet {
                    red: 0,
                    green: 0,
                    blue: 0,
                };

                let string_sets = set.split(",").map(|x| x.trim());
                for set_str in string_sets {
                    parse_cube_set(&mut cube_set, set_str);
                }

                cube_set
            })
            .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>()
}

fn parse_cube_set<'a>(cube_set: &'a mut CubeSet, cube: &str) -> &'a CubeSet {
    match cube.split(" ").collect::<Vec<_>>().as_slice() {
        [n, color] => {
            let n = n.parse::<u32>().expect("Invalid amount");
            match *color {
                "red" => cube_set.red = n,
                "green" => cube_set.green = n,
                "blue" => cube_set.blue = n,
                _ => panic!("Invalid color"),
            }
        }
        _ => panic!("Invalid format"),
    }
    cube_set
}
