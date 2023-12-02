use std::cmp;
use std::fs;

#[derive(Debug)]
struct CubeSet {
    red: u32,
    green: u32,
    blue: u32,
}

impl CubeSet {
    const fn empty() -> CubeSet {
        CubeSet::from(0, 0, 0)
    }

    const fn from(red: u32, green: u32, blue: u32) -> CubeSet {
        CubeSet { red, green, blue }
    }
}

const LIMIT: CubeSet = CubeSet::from(12, 13, 14);

fn main() {
    let cont = fs::read_to_string("input").expect("File not found");
    let lines: Vec<_> = cont.lines().collect();
    let games = parse_games(&lines);

    println!("Part 1: {}", solve1(&games));
    println!("Part 2: {}", solve2(&games));
}

fn solve1(games: &Vec<Vec<CubeSet>>) -> usize {
    games
        .iter()
        .map(get_max_cubes)
        .enumerate()
        .filter(|(_, x)| is_valid(x))
        .map(|(i, _)| i + 1)
        .sum()
}

fn solve2(games: &Vec<Vec<CubeSet>>) -> u32 {
    games.iter().map(get_max_cubes).map(get_power).sum()
}

fn get_power(cube_set: CubeSet) -> u32 {
    cube_set.red * cube_set.green * cube_set.blue
}

fn is_valid(cube_set: &CubeSet) -> bool {
    return cube_set.red <= LIMIT.red
        && cube_set.green <= LIMIT.green
        && cube_set.blue <= LIMIT.blue;
}

fn get_max_cubes(game: &Vec<CubeSet>) -> CubeSet {
    let mut max = CubeSet::empty();

    for set in game {
        max.red = cmp::max(max.red, set.red);
        max.green = cmp::max(max.green, set.green);
        max.blue = cmp::max(max.blue, set.blue);
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
                let mut cube_set = CubeSet::empty();
                let string_sets = set.split(",").map(|x| x.trim());
                for set in string_sets {
                    parse_cube_set(&mut cube_set, set);
                }

                cube_set
            })
            .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>()
}

fn parse_cube_set<'a>(cube_set: &'a mut CubeSet, cube: &str) -> &'a CubeSet {
    let cube_properties = cube.split(" ").collect::<Vec<_>>();
    let [n, color] = cube_properties.as_slice() else {
        panic!("Invalid format");
    };

    let n = n.parse::<u32>().expect("Invalid amount");
    match *color {
        "red" => cube_set.red = n,
        "green" => cube_set.green = n,
        "blue" => cube_set.blue = n,
        _ => panic!("Invalid color"),
    }

    cube_set
}
