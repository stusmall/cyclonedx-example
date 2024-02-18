build:
	cargo build --release
	cargo run --bin uniffi-bindgen generate --library target/release/libcyclonedx_example.so --language python --out-dir bindings/python/cyclonedx_example/
	cp target/release/libcyclonedx_example.so bindings/python/cyclonedx_example/libcyclonedx_example.so
	cd bindings/python && poetry build
test:
	cargo test
	poetry install -C bindings/python/
	poetry run -C bindings/python/ pytest

clean:
	cargo clean
	rm -rf bindings/python/dist
	rm bindings/python/cyclonedx_example/libcyclonedx_example.so
	rm -rf sboms

generate-sbom:
	mkdir -p sboms
	cargo cyclonedx -f json --output-prefix core  --output-cdx
	mv core.cdx.json sboms/
	poetry install -C bindings/python/
	poetry run -C bindings/python/ cyclonedx-py poetry --no-dev --outfile sboms/python-only.cdx.json bindings/python/
	cyclonedx merge --input-files sboms/core.cdx.json sboms/python-only.cdx.json  --output-format json > sboms/python.cdx.json
	rm sboms/core.cdx.json sboms/python-only.cdx.json

check-sbom:
	trivy sbom sboms/python.cdx.json