{% docs shopify_source_relation %}
The schema or database this record came from if you are making use of the `shopify_union_schemas` or `shopify_union_databases` variables, respectively. Empty string if you are not using either of these variables to union together multiple Shopify connectors.
{% enddocs %}

{% docs shopify_transaction_kind %}
The transaction's type. Valid values:
- authorization: Money that the customer has agreed to pay.
- capture: A transfer of money that was reserved during the authorization of a shop.
- sale: The authorization and capture of a payment performed in one single step.
- void: The cancellation of a pending authorization or capture.
- refund: The partial or full return of captured money to the customer.
{% enddocs %}