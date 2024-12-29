class UpdatesController < ApplicationController
  before_action :set_update, only: %i[ show edit update destroy ]

  # GET /updates or /updates.json
  def index
    @updates = Update.all
  end

  # GET /updates/1 or /updates/1.json
  def show
  end

  # GET /updates/new
  def new
    @update = Update.new
  end

  # GET /updates/1/edit
  def edit
  end

  # POST /updates or /updates.json
  def create
    @update = Update.new(update_params)

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, notice: "Update was successfully created." }
        format.json { render :show, status: :created, location: @update }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates/1 or /updates/1.json
  def update
    respond_to do |format|
      if @update.update(update_params)
        format.html { redirect_to @update, notice: "Update was successfully updated." }
        format.json { render :show, status: :ok, location: @update }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates/1 or /updates/1.json
  def destroy
    @update.destroy!

    respond_to do |format|
      format.html { redirect_to updates_path, status: :see_other, notice: "Update was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def update_params
      params.expect(update: [ :event_id, :title, :body ])
    end
end
