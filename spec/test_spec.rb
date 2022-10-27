describe "商品の実装" do
	let!(:item) { create(:item, genre_id: 0) }
	context "商品一覧" do
		before do
			visit items_path
		end
		it "商品クリックで商品画面に遷移するか" do
			link = find_all('.item_list a')[1].native.inner_text.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
			click_link link
			is_expected.to eq '/items/' + item.id.to_s
		end
	end
end