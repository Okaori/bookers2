class BooksController < ApplicationController

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @books = Book.all
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    if @user.id != current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :edit
    end
  end

  # 投稿データの保存
  def create
    @user = current_user
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :index
    end
  end

  def destroy
    book = Book.find(params[:id]) # データの取得(idを用いて1件ずつ)
    if book.destroy # データの削除
      flash[:notice] = "Book was successfully destroyed."
      redirect_to books_path
    else
      render :index
    end
  end


  # 投稿データのストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body)
  end


end
