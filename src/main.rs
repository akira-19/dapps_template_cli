mod downloader;
use downloader::zip_extractor;
use inquire::InquireError;
use inquire::Select;
use tokio;

#[tokio::main]
async fn main() {
    let options: Vec<&str> = vec!["Contract", "Frontend", "Others"];

    let contract_options: Vec<&str> = vec!["erc721", "erc20"];

    // let ans: Result<&str, InquireError> =
    //     Select::new("Select the project you want?", options).prompt();

    let mut url = "";

    let choice = new_options(options).unwrap();

    // match ans {
    //     Ok(choice) => match choice {
    //         "Contract" => url = "https://github.com/oasysgames/oasys-validator/releases/download/v1.3.0/genesis.zip",
    //         "Frontend" => println!("Apples are great too!"),
    //         "Others" => println!("Strawberries are the best!"),
    //         _ => println!("I don't know that fruit"),
    //     },
    //     Err(_) => println!("There was an error, please try again"),
    // }

    std::process::exit(zip_extractor(url).await);
}

fn new_options(options: Vec<&str>) -> Result<&str, InquireError> {
    let ans: Result<&str, InquireError> =
        Select::new("Select the project you want?", options).prompt();

    return ans;

    // match ans {
    //     Ok(choice) => return choice,
    //     Err(_) => println!("There was an error, please try again"),
    // }
}
