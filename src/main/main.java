package main;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.*;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyCodeCombination;
import javafx.scene.input.KeyCombination;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import java.io.*;

public class main extends Application{

    public Stage window;
    public BorderPane layout;
    public Scene scene;
    public File selectedfile;
    public HBox right;
    public VBox vb;

    public static void main(String args[]){
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        window =  primaryStage;
        window.setTitle("P-S picker");
        Menu file = new Menu("Project");

        MenuItem openNewData= new MenuItem("Open New Data    Ctrl+O");
        openNewData.setOnAction(e -> openproject());

        MenuItem saveData=    new MenuItem("Save Project          Ctrl+S");
        saveData.setOnAction(e -> saveproject());

        MenuItem saveAsData = new MenuItem("Save As Project     Ctrl+A");
        saveAsData.setOnAction(e -> saveasproject());

        file.getItems().addAll(openNewData,saveData,saveAsData);

        MenuBar top = new MenuBar();
        top.getMenus().add(file);

        layout = new BorderPane();

        layout.setTop(top);

        Button p= new Button("Tp");
        Button s= new Button("Ts");
        Button ss= new Button("Tss");

        right = new HBox(10);
        right.setPadding(new Insets(20,50,50,50));
        right.setAlignment(Pos.TOP_CENTER);
        right.disableProperty();
        right.getChildren().addAll(p,s,ss);

        vb = new VBox(20);
        vb.setPadding(new Insets(10,0,50,50));
        vb.setAlignment(Pos.BASELINE_LEFT);
        Label tp = new Label("Tp : Not picked");
        Label thap = new Label("Thap : Not Calculated");
        Label mvhap = new Label("mVhaP : Not Calculated");
        Label ts = new Label("Ts : Not picked");
        Label thas = new Label("Thas : Not Calculated");
        Label mvhas = new Label("mVhas : Not Calculated");
        Label tss = new Label("Tss : Not picked");
        Label thass = new Label("Thass : Not Calculated");
        Label mvhass = new Label("mVhass : Not Calculated");

        vb.getChildren().addAll(right,tp,thap,mvhap,ts,thas,mvhas,tss,thass,mvhass);

        scene = new Scene(layout,1000,500);

        scene.getAccelerators().put(
                new KeyCodeCombination(KeyCode.O, KeyCombination.SHORTCUT_DOWN),
                () -> openproject()
        );
        scene.getAccelerators().put(
                new KeyCodeCombination(KeyCode.S, KeyCombination.SHORTCUT_DOWN),
                () -> saveproject()
        );
        scene.getAccelerators().put(
                new KeyCodeCombination(KeyCode.A, KeyCombination.SHORTCUT_DOWN),
                () -> saveasproject()
        );
        window.setScene(scene);
        window.show();
    }

    public LineChart<Number,Number> datadisplay(){
        final NumberAxis xAxis = new NumberAxis();
        final NumberAxis yAxis = new NumberAxis();
        xAxis.setLabel("time in microsecond");
        yAxis.setLabel("milliVolt");
        //creating the chart
        final LineChart<Number,Number> lineChart =
                new LineChart<Number,Number>(xAxis,yAxis);

        lineChart.setCreateSymbols(false);

        //defining a series
        XYChart.Series series = new XYChart.Series();
        series.setName("Synthetic Seismogram");

        //populating the series with data
        BufferedReader bufferedReader;
        try {
            bufferedReader = new BufferedReader(new FileReader(selectedfile));
            String text;
            while ((text = bufferedReader.readLine()) != null && text.length()>0) {
                String a[]=text.split(",");
                series.getData().add(new XYChart.Data(Double.parseDouble(a[0]), Double.parseDouble(a[1])));
            }
        } catch (FileNotFoundException ex) {
//            Logger.getLogger(JavaFX_OpenFile.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
//            Logger.getLogger(JavaFX_OpenFile.class.getName()).log(Level.SEVERE, null, ex);
        } finally {

        }

        lineChart.getData().add(series);

        return lineChart;
    }

    public void openproject(){
        FileChooser filedir = new FileChooser();
        filedir.getExtensionFilters().add(new FileChooser.ExtensionFilter("ISF files", "*.isf"));
        filedir.setTitle("Open ISF file");
        selectedfile =  filedir.showOpenDialog(window);
        if(selectedfile!= null){

            LineChart<Number,Number> graph = datadisplay();
            layout.setCenter(graph);
            layout.setRight(vb);
            try {
                scene = new Scene(layout, 1000, 500);
            }
            catch (IllegalArgumentException e ){}
            window.setScene(scene);
        }
    }

    public void saveproject(){

    }

    public void saveasproject(){

    }
}