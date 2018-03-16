extern crate futures;
extern crate grpcio;
extern crate protobuf;

//Links the the generated gRPC code
pub mod route_guide {
    include!(concat!(env!("OUT_DIR"), "/route_guide/mod.rs"));
}
