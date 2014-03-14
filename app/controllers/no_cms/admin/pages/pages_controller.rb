require_dependency "no_cms/admin/pages/application_controller"

module NoCms::Admin::Pages
  class PagesController < ApplicationController

    before_filter :load_menu_section
    before_filter :load_page, only: [:edit, :update, :destroy]
    before_filter :load_roots, only: [:index, :new, :edit]


    def new
      @page = NoCms::Pages::Page.new
    end

    def create
      @page = NoCms::Pages::Page.new page_params
      if @page.save
        @logger.info(I18n.t('.no_cms.admin.pages.pages.create.success', title: @page.path), true)
        redirect_after_save
      else
        @logger.error(I18n.t('.no_cms.admin.pages.pages.create.error', title: @page.path))
        load_roots
        render :new
      end
    end

    def edit
      @logger.add_message :pages, I18n.t('.no_cms.admin.pages.pages.edit.log_messages', title: @page.path)
      NoCms::Pages.block_layouts.each do |name, _|
        @page.blocks.build layout: name
      end
    end

    def update
      if @page.update_attributes page_params
        @logger.info(I18n.t('.no_cms.admin.pages.pages.update.success', title: @page.path), true)
        redirect_after_save
      else
        @logger.error(I18n.t('.no_cms.admin.pages.pages.update.error', title: @page.path))
        load_roots
        render :new
      end
    end

    def destroy
      if @page.destroy
        @logger.info(I18n.t('.no_cms.admin.pages.pages.destroy.success', title: @page.path), true)
      else
        @logger.error(I18n.t('.no_cms.admin.pages.pages.destroy.error', title: @page.path), true)
      end
      redirect_to pages_path
    end

    private

    def load_menu_section
      @current_section = 'pages'
    end

    def load_page
      @page = NoCms::Pages::Page.find(params[:id])
    end

    def load_roots
      @roots = NoCms::Pages::Page.roots
    end

    def page_params
      page_params = params.require(:page).permit(:title, :body, :parent_id, :draft)
      page_params.merge!(blocks_attributes: params[:page][:blocks_attributes]) unless params[:page][:blocks_attributes].blank?
      page_params
    end

    def redirect_after_save
      if params[:submit_and_hide]
        redirect_to pages_path
      elsif params[:submit_and_new]
        redirect_to new_page_path
      else params[:submit]
        redirect_to edit_page_path(@page)
      end

    end

  end
end
