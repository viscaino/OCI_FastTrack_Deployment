# Sample without use data source

When we use data sources as a map, some resources could be flagged as "forces replacement".

A resource with "forces replacement" flag will be destroyed and recreated on the next execution.
PS.: you can validate get this message executing "terraform plan".

To fix this "issue" I developed some scripts that use resources reference instead of data sources, after this update **no one** resource is flagged as "forces replacement" 