class CampisController < ApplicationController
  # GET /campis
  # GET /campis.json
  def index
    @campis = Campi.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @campis }
    end
  end

  # GET /campis/1
  # GET /campis/1.json
  def show
    @campi = Campi.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @campi }
    end
  end

  # GET /campis/new
  # GET /campis/new.json
  def new
    @campi = Campi.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @campi }
    end
  end

  # GET /campis/1/edit
  def edit
    @campi = Campi.find(params[:id])
  end

  # POST /campis
  # POST /campis.json
  def create
    @campi = Campi.new(params[:campi])

    respond_to do |format|
      if @campi.save
        format.html { redirect_to @campi, :notice => 'Campi was successfully created.' }
        format.json { render :json => @campi, :status => :created, :location => @campi }
      else
        format.html { render :action => "new" }
        format.json { render :json => @campi.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /campis/1
  # PUT /campis/1.json
  def update
    @campi = Campi.find(params[:id])

    respond_to do |format|
      if @campi.update_attributes(params[:campi])
        format.html { redirect_to @campi, :notice => 'Campi was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @campi.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /campis/1
  # DELETE /campis/1.json
  def destroy
    @campi = Campi.find(params[:id])
    @campi.destroy

    respond_to do |format|
      format.html { redirect_to campis_url }
      format.json { head :ok }
    end
  end
end
