FactoryBot.define do

  factory :item do
    name              {"abe"}
    price                 {350}
    text              {"aaaaaaa"}
    status                    {1}
    size                      {1}
    condition                 {1}
    shipping_cost             {1}
    delivery_method           {1}
    delivery_area             {1}
    delivery_date             {1}
    category_id               {1}
    seller_id                 {1}
    buyer_id                  {2} 
  end
end


