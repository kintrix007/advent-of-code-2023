use std::fs;

#[derive(Debug)]
struct CubeSet {
    red: u32,
    green: u32,
    blue: u32,
}

fn main() {
    let cont = fs::read_to_string("input").expect("File not found");
    let lines: Vec<_> = cont.lines().collect();
    let games = parse_games(lines);
    println!("{:?}", games);
}

fn parse_games<'a>(lines: Vec<&'a str>) -> Vec<Vec<CubeSet>> {
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
