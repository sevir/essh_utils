driver "deno" { 
    engine = [=[
        {{template "environment" .}}

        # Detect if deno is installed
        if ! command -v deno &> /dev/null
        then
            echo "Deno could not be found. Please install it."
            exit 1
        fi
        
        set -e
deno run --unstable -q -A - <<EOF
{{range $i, $script := .Scripts -}}
    {{$script.code}} 
{{end -}}

EOF
        set +e
    ]=],
}

driver "python" {
    engine = [=[
        {{template "environment" .}}

        # Detect if python or python3 is installed, python3 is preferred
        if ! command -v python3 &> /dev/null
        then
            if ! command -v python &> /dev/null
            then
                echo "Python could not be found. Please install it."
                exit 1
            else
                CMD=python
            fi
        else
                CMD=python3
        fi
        
        
        set -e

$CMD <<EOF
{{range $i, $script := .Scripts -}}
{{$script.code}} 
{{end -}}
EOF

        set +e
    ]=],
}

driver "essh-lua" {
    engine = [=[
        {{template "environment" .}}

        # Detect if essh is installed
        if ! command -v essh &> /dev/null
        then
            # Try to extend the PATH
            export PATH=$PATH:$HOME/.bin
            if ! command -v essh &> /dev/null
            then
                echo "essh could not be found. Please install it."
                exit 1
            fi
        fi
        
        set -e

essh --eval <<EOF
{{range $i, $script := .Scripts -}}
{{$script.code}} 
{{end -}}
EOF

        set +e
    ]=],
}