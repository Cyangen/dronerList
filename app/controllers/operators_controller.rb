class OperatorsController < ApplicationController
  before_action :set_operator, only: [:show, :edit, :update, :destroy]

  require 'open-uri'


  # GET /operators
  # GET /operators.json
  def index
    @operators = Operator.all

    doc = Nokogiri::HTML(open("http://moduliweb.enac.gov.it/applicazioni/SAPR/APR_ReportAutorizzazioniOperatori.asp"))

    table = doc.at('table')

    table.search('tr').each do |tr|
      cells = tr.search('th, td')

      # operators name
      puts cells[3].text.strip.split(':')[0].gsub('pec','')

      # operators pec
      cells[3].text.strip.split(':')[1]

      cells.each do |cell|
        text = cell.text.strip

        # puts text
      end

      # output cell data
    end

  end

  # GET /operators/1
  # GET /operators/1.json
  def show
  end

  # GET /operators/new
  def new
    @operator = Operator.new
  end

  # GET /operators/1/edit
  def edit
  end

  # POST /operators
  # POST /operators.json
  def create
    @operator = Operator.new(operator_params)

    respond_to do |format|
      if @operator.save
        format.html { redirect_to @operator, notice: 'Operator was successfully created.' }
        format.json { render :show, status: :created, location: @operator }
      else
        format.html { render :new }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operators/1
  # PATCH/PUT /operators/1.json
  def update
    respond_to do |format|
      if @operator.update(operator_params)
        format.html { redirect_to @operator, notice: 'Operator was successfully updated.' }
        format.json { render :show, status: :ok, location: @operator }
      else
        format.html { render :edit }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operators/1
  # DELETE /operators/1.json
  def destroy
    @operator.destroy
    respond_to do |format|
      format.html { redirect_to operators_url, notice: 'Operator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator
      @operator = Operator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operator_params
      params.require(:operator).permit(:name, :drone_type, :scenario)
    end
end
