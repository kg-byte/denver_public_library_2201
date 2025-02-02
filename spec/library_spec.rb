require './lib/book'
require './lib/author'
require './lib/Library'

RSpec.describe Library do

  before(:each) do
    @dpl = Library.new("Denver Public Library")
  end
    it "exists" do
      expect(@dpl).to be_an_instance_of(Library)
    end

    it "has a name" do
      expect(@dpl.name).to eq("Denver Public Library")
    end

    it "has no books when initialized" do
      expect(@dpl.books).to eq([])
    end

    it "has no authors listed when initialized" do
      expect(@dpl.authors).to eq([])
    end

    it "can add authors and their books" do
      charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
      jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
      professor = charlotte_bronte.write("The Professor", "1857")
      villette = charlotte_bronte.write("Villette", "1853")
      harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
      mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

      @dpl.add_author(charlotte_bronte)
      @dpl.add_author(harper_lee)
      expect(@dpl.authors).to eq([charlotte_bronte, harper_lee])
      expect(@dpl.books).to eq([jane_eyre, professor, villette, mockingbird])
    end

    it "can get publication time frame for a selected author" do
      charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
      jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
      professor = charlotte_bronte.write("The Professor", "1857")
      villette = charlotte_bronte.write("Villette", "1853")
      harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
      mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

      expect(@dpl.publication_time_frame_for(charlotte_bronte)).to eq({:start =>"1847", :end =>"1857"})
      expect(@dpl.publication_time_frame_for(harper_lee)).to eq({:start =>"1960", :end =>"1960"})
    end

    it "can check out a book when available and returns false when not" do
      charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
      jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
      professor = charlotte_bronte.write("The Professor", "1857")
      villette = charlotte_bronte.write("Villette", "1853")
      harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
      mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

      expect(@dpl.checkout(mockingbird)).to be false
      expect(@dpl.checkout(jane_eyre)).to be false

      @dpl.add_author(charlotte_bronte)
      @dpl.add_author(harper_lee)
      expect(@dpl.checkout(mockingbird)).to be true
      expect(@dpl.checked_out_books).to eq([mockingbird])

    end

    it "can return a book and show it's no longer checked out " do
      charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
      jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
      professor = charlotte_bronte.write("The Professor", "1857")
      villette = charlotte_bronte.write("Villette", "1853")
      harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
      mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")


      @dpl.add_author(charlotte_bronte)
      @dpl.add_author(harper_lee)
      @dpl.checkout(jane_eyre)
      @dpl.return(jane_eyre)
      expect(@dpl.checked_out_books).to eq([])
    end


    it "shows the most popular books" do
      charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
      jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
      professor = charlotte_bronte.write("The Professor", "1857")
      villette = charlotte_bronte.write("Villette", "1853")
      harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
      mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

      @dpl.add_author(charlotte_bronte)
      @dpl.add_author(harper_lee)
      @dpl.checkout(jane_eyre)
      @dpl.checkout(villette)
      @dpl.checkout(mockingbird)
      @dpl.return(mockingbird)
      @dpl.checkout(mockingbird)
      @dpl.return(mockingbird)
      @dpl.checkout(mockingbird)
      expect(@dpl.most_popular_book).to eq(mockingbird)

    end
end
