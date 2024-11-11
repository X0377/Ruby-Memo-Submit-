require "csv"

#新規作成のメソッド
def create_new_memo
  puts "メモのタイトルを入力してください(拡張子不要)"
  @memo_title = gets.chomp
  if @memo_title.length >= 1 
    puts "メモしたい内容を入力してください"
    puts "完了したらEnterの後にCtrl＋Dを押してください" 
    @memo_content = []
    while input = gets
      @memo_content << input.chomp
    end
  elsif @memo_title == ""
    puts "タイトルが入力されていません"
    create_new_memo
  end
end

#保存のメソッド
def save_memo
  if @memo_content.length >= 1
    while @memo_content.all? { |line| line.empty? } #全ての行が空白の間繰り返す
      puts "内容が空のメモは保存できません"
      puts "メモしたい内容を入力してください"
      puts "完了したらEnterの後にCtrl＋Dを押してください"
      puts "※終了するには「Ctrl＋C」を押してください"
      @memo_content = []
      while input = gets
        @memo_content << input.chomp
      end
    end

    begin
      CSV.open("#{@memo_title}.csv",'w') do |content|
      content << @memo_content 
      end

      puts "#{@memo_title}を保存しました"

    rescue StandardError => e
      puts "保存に失敗しました"
    end

  elsif @memo_content.length == 0
    puts "内容が入力されていません"
    while input = gets
      @memo_content << input.chomp
    end
  end
end

#編集のメソッド
def edit_memo
  puts "編集したいメモのタイトルを入力してください(拡張子不要)"
  puts "メモ一覧を確認したい場合は「--list」と入力してください"
  @memo_title = gets.chomp 

  if @memo_title == "--list"
    output_all_memo

  elsif 
    File.exist?("#{@memo_title}.csv")
    puts "メモの内容を表示します"

    memo_data = CSV.read("#{@memo_title}.csv")
    puts "--------------------"
    puts memo_data
    puts "--------------------"
    puts "1：内容を全て書き直す"
    puts "2：現在の内容に追記する"
    @select_edit_menu = gets.chomp

    case @select_edit_menu
    when "1"
      puts "新しい内容を入力してください"
      puts "編集が完了したらEnterの後にCtrl＋Dを押してください"
      @memo_content = [] 
      while input = gets
        @memo_content << input.chomp
      end
      save_memo
    when "2"
      CSV.open("#{@memo_title}.csv", "a") do |content|
        puts "追記する内容を入力してください"
        puts "編集が完了したらEnterの後にCtrl＋Dを押してください"
        while input = gets
          content << [input.chomp]
        end
        puts "#{@memo_title}に追記して保存しました"
      end 
    end

  else     
    puts "指定されたメモが見つかりません"
    puts "1：再度入力する"
    puts "2：メインメニューに戻る"
    puts "※終了するには「Ctrl＋C」を押してください"
    @retry_edit_option = gets.chomp
    case @retry_edit_option
    when "1"
      edit_memo 
    when "2"
      select_menu
    end
  end
end


#削除のメソッド
def delete_memo
  puts "削除したいメモのタイトルを入力してください(拡張子不要)"
  puts "メモ一覧を確認したい場合は「--list」と入力してください"
  @memo_title = gets.chomp 
  if @memo_title == "--list"
    output_all_memo

  elsif File.exist?("#{@memo_title}.csv") 
    puts "#{@memo_title}を削除します"
    loop do
      puts "よろしいですか？ Y / N"
      @confirm_delete = gets.chomp
      
      case @confirm_delete
      when "Y"
        File.delete("#{@memo_title}.csv")
        puts "ファイルを削除しました"
        break
      when "N"
        puts "削除を中止しました"
        break
      else
        puts "「Y」または「N」を押してください"
      end
    end
  else
    puts "指定されたメモが見つかりません"
    puts "1：再度入力する"
    puts "2：メインメニューに戻る"
    puts "※終了するには「Ctrl＋C」を押してください"
    @retry_delete_option = gets.chomp
    case @retry_delete_option
    when "1"
      delete_memo 
    when "2"
      select_menu
    end
  end
end

#一覧表示のメソッド
def output_all_memo
  puts "メモ一覧"
  puts "--------------------"
  Dir.glob('*.csv').each do |filename|
    puts filename 
  end
  puts "--------------------"
  select_menu
end


#メニュー選択のメソッド
def select_menu
  puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する / 3 → 既存のメモを削除する / 4 → メモ一覧を表示する"
  puts "※終了するには「Ctrl＋C」を押してください"
  memo_type = gets.to_i 

  if memo_type == 1 
    create_new_memo
    save_memo
  elsif memo_type == 2
    edit_memo
  elsif memo_type == 3
    delete_memo
  elsif memo_type == 4
    output_all_memo
  else
    puts "1, 2, 3, 4のいずれかを入力してください"
    puts "※終了するには「Ctrl＋C」を押してください"
    select_menu
  end
end

#処理
select_menu