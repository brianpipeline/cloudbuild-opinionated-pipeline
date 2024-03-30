#!/bin/bash
deployPipelines() {
    pipelineDirectory="$1"

    while read -r pipelineYaml; do
        # TODO: do webhook pipelines for now, but eventually create a pipeline metadata file for each pipeline to describe which type of pipeline they are.
        pipelineName=$(basename "$pipelineYaml" | cut -f 1 -d '.')
        substitutions=$(yq eval '.substitutions' "$pipelineYaml")
        substitutionsInOneLine=""
        for substitution in $substitutions; do
            # Check if the final character is ":"
            if [ "${substitution: -1}" = ":" ]; then
                # If it is, replace ":" with "=" using parameter expansion
                substitution="${substitution%?}="
            fi
            if [[ $substitution =~ [\)\""}"]$ ]]; then
                substitutionsInOneLine="$substitutionsInOneLine$substitution,"
            else
                substitutionsInOneLine="$substitutionsInOneLine$substitution"
            fi
        done
        if [[ -z "$(gcloud builds triggers describe "$pipelineName" --region=us-central1 2>&1 >/dev/null)" ]]; then
            echo "Pipeline $pipelineName already exists. Updating."
            temp_file=$(mktemp)
            yq eval 'del(.substitutions)' "$pipelineYaml" >"$temp_file"
            if ! (gcloud builds triggers update webhook "$pipelineName" --region="us-central1" --clear-substitutions --inline-config="$temp_file" && gcloud builds triggers update webhook "$pipelineName" --region="us-central1" --update-substitutions "$substitutionsInOneLine" --inline-config="$temp_file"); then
                echo "Failed to update pipeline $pipelineName"
                exit 1
            fi
        else
            echo "Creating pipeline $pipelineName"
            if ! gcloud builds triggers create webhook --name="$pipelineName" --secret="projects/212799175996/secrets/webhook-secret/versions/1" --region="us-central1" --inline-config="$pipelineYaml" --substitutions "$substitutionsInOneLine"; then
                echo "Failed to create pipeline $pipelineName"
                exit 1
            fi
        fi
    done < <(find "$pipelineDirectory" -type d -name tests -prune -o -type f -print)

    echo "All pipelines deployed."
}
