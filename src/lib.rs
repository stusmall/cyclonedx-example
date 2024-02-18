uniffi::setup_scaffolding!();
#[uniffi::export]
fn library_function(input: u32) -> String {
    format!("{}", input)
}

#[test]
fn basic_test(){
    assert_eq!(library_function(3), "3".to_string());
}