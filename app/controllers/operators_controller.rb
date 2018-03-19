class OperatorsController < ApplicationController
  before_action :set_operator, only: [:show, :edit, :update, :destroy]

  require 'open-uri'


  # GET /operators
  # GET /operators.json
  def index

    if params[:operator]
      @operators = Operator.where('address LIKE ?', "%#{params[:operator].capitalize}%")
    else
      @operators = Operator.take(20)
    end

    # mechanize = Mechanize.new
    # 23.times do
    #   page_number = 1
    # doc = Nokogiri::HTML(open("https://www.dronezine.it/database-operatori-droni-e-costruttori-uav/visualizzazione-database-operatori-professionali-droni-e-uav/?listpage=" + page_number.to_s))
    #
    #   table = doc.at('table')
    #   table.search('tr').each do |tr|
    #     cells = tr.search('th, td')
    #     name = cells[0].text.strip
    #     address = cells[1].text.strip + ' ' + cells[2].text.strip
    #     info = cells[5].text.strip
    #     website = cells[4].text.strip
    #
    #     Operator.create(name: name, infos:info, website:website, address:address).save
    #   end
    #
    #   page_number = page_number + 1
    # end


    # doc2 = Nokogiri::HTML(open("https://www.dronezine.it/piloti/"))
    # table2 = doc2.at('table')
    #
    # table2.search('tr').each do |tr|
    #   cells = tr.search('th, td')
    #   name = cells[2].text.strip + cells[3].text.strip
    #   address = cells[1].text.strip + ' ' + cells[0].text.strip
    #   phone = cells[4].text.strip
    #   pec = cells[5].text.strip
    #
    #   Operator.create(name: name, pec: pec, phone:phone, address:address).save
    # end

    # puts '0000000000000000000000000000000'
    # puts Operator.count


  end

  def init
    # enac sapr oprators
    doc = Nokogiri::HTML(open("http://moduliweb.enac.gov.it/applicazioni/SAPR/APR_ReportAutorizzazioniOperatori.asp"))
    table = doc.at('table')

    table.search('tr').each do |tr|
      cells = tr.search('th, td')

      name = cells[3].text.strip.split(':')[0].gsub('pec','')
      pec = cells[3].text.strip.split(':')[1]
      weight = cells[8].text.strip
      scenario = cells[9].text.strip
      type = cells[4].text.strip

      # get additional infos from registroimprese
      mechanize = Mechanize.new
      page = mechanize.get('http://www.registroimprese.it/home')
      form = page.forms.first
      form['_1_WAR_ricercaRIportlet_inputSearchField'] = name
      page = form.submit
      table = page.at('table')
      tbody = table.at('tbody')

      if tbody.search('tr')[0]
        tr = tbody.search('tr')[0]
        div = tr.search('div')[12]
        address = div.search('span')[0].text
      else
        address = nil
      end

      # multiple drones for one operator
      if Operator.exists?(name: name)
        operator = Operator.find_by(name: name)
        operator.drone_type = operator.drone_type + '/' + type
        operator.save
      else
        Operator.create(name: name, pec: pec, weight:weight, scenario:scenario, drone_type:type, address:address).save
      end

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
      if params[:operator].is_a? String
        params[:operator]
      else
        params.require(:operator).permit(:name, :drone_type, :scenario, :pec, :weight)
      end
    end
end
