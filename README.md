# GitOps Helm Value Update

This action will update a Helm Value file and commit to the branch. This was implemented as part of the automated GitOps workflow implementation. 

## How to use 

Use the action as below and find the explation of the options.

*bot_name :* Name of the Git commiter account.
*helm_variable :* Respective `Helm Key` following the single line format, separating nested option in a `.`
*helm_value :* Respective actual value `Helm Value` of the above key. This is the value being updated in this action.
*helm_value_file_path :* Path of the value file, this doesn't contain file (Ex: if value file is located in `folder1/folder2/value-file.yaml` , value for this option should be `helm_value_file_path`)
*helm_value_file_name :* Value file name (Ex: above file path value should be `value-file.yaml`)
*version :* Optional value, this is the `yq` version default is `v4.30.5`

```
- name: Test workflow deployment for airflow component
uses: arunalakmal/gitops-helm-value-update@main
with:
    bot_name: "GitOpsDeployer"
    helm_variable: "images.airflow.tag"
    helm_value: '${{ github.event.client_payload.airflow_image_tag }}'
    helm_value_file_path: "envs/test"
    helm_value_file_name: "values-test.yaml"
```