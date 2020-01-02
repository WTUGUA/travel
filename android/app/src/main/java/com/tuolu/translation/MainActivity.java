package com.tuolu.translation;

import android.app.Activity;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.Manifest;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.baidu.translate.asr.OnRecognizeListener;
import com.baidu.translate.asr.TransAsrClient;
import com.baidu.translate.asr.TransAsrConfig;
import com.baidu.translate.asr.data.RecognitionResult;
import com.umeng.analytics.MobclickAgent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL ="samples.flutter.io/asr";
  private static final String TAG = "MainActivity";
  private static final String APP_ID = "20190809000325332";
  private static final String SECRET_KEY = "luTbBoWAQY3uGV8rtxog";
  String to="";
  String from;
  String resultFrom="";
  String resultTo="";
  private TransAsrClient client;
  private TransAsrConfig config;
  //申请录音权限
  private static final int GET_RECODE_AUDIO = 1;
  private static String[] PERMISSION_AUDIO = {
          Manifest.permission.RECORD_AUDIO
  };
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    verifyAudioPermissions(MainActivity.this);
    initClient();
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                // TODO
                try {
                  from=call.argument("from");
                  to=call.argument("to");
                } catch (Exception e) {
                  e.printStackTrace();
                }
                // Toast.makeText(MainActivity.this,from.toString(),Toast.LENGTH_SHORT).show();
                if (call.method.equals("start")) {
                  //Toast.makeText(MainActivity.this,"对话识别开始",Toast.LENGTH_SHORT,).show();
                  startRecognize();
                  result.success("sucess");
                }

                if(call.method.equals("stop")){
                 // Toast.makeText(MainActivity.this,"对话识别停止",Toast.LENGTH_SHORT).show();
                  stopRecognize();
                  result.success("stop");
                }
                else{
                  result.notImplemented();
                }
              }
            });
    //获取flutter端传来的数据按下启动
  }
  private void initClient() {
    // 【重要】语音翻译配置类
    // appId及私钥，可在API平台 管理控制台 查看
    config = new TransAsrConfig(APP_ID, SECRET_KEY);

    // 构造client
    client = new TransAsrClient(this, config);
    // 设置回调
    client.setRecognizeListener(new OnRecognizeListener() {
      @Override
      public void onRecognized(int resultType, @NonNull RecognitionResult result) {
        if (resultType == OnRecognizeListener.TYPE_PARTIAL_RESULT) { // 中间结果
          Log.d(TAG, "中间识别结果：" + result.getAsrResult());
          String shibieresult= result.getAsrResult();

        } else if (resultType == OnRecognizeListener.TYPE_FINAL_RESULT) { // 最终结果
          if (result.getError() == 0) { // 表示正常，有识别结果
            Log.d(TAG, "最终识别结果：" + result.getAsrResult());
            Log.d(TAG, "翻译结果：" + result.getTransResult());
            // 语音识别结果
            resultFrom=result.getAsrResult();
            // 翻译结果并将翻译结果发送给flutter端
            resultTo=result.getTransResult();
            Map<String,String> mapresult=new HashMap<String,String>();
            mapresult.put("resultFrom",resultFrom);
            mapresult.put("resultTo",resultTo);
            MethodChannelPlugin.registerWith(getFlutterView()).invokeMethod("result",mapresult);
          } else { // 翻译出错
            Log.d(TAG, "语音翻译出错 错误码：" + result.getError() + " 错误信息：" + result.getErrorMsg());
            if(result.getError()==607001){
              Toast.makeText(MainActivity.this,"识别失败请重试，或提高音频质量",Toast.LENGTH_SHORT).show();
            }
            if(result.getError()==58001){
              Toast.makeText(MainActivity.this, "暂不支持此语言的语言翻译", Toast.LENGTH_SHORT).show();
            }
            // String  error=result.getError()+result.getErrorMsg();
          }
        }
      }

    });
  }
  private void startRecognize() {
    Log.d(TAG, "开始语音识别");

    //resultText.setText("");

    // ===== 以下是根据选项进行配置，一般情况下，普通开发者的配置是不变的。======
    // 是否回调中间结果（可用于连续上屏），默认为false
    //  config.setPartialCallbackEnabled(partialCheck.isChecked());
    // 是否自动播报译文结果（仅支持11种语言），默认为true
    config.setAutoPlayTts(true);
    // 英语 英式发音、美式发音配置
    //if (ttsTypeGroup.getCheckedRadioButtonId() == R.id.eng_tts_uk_radio) {
    //     config.setTtsEnglishType(TransAsrConfig.TTS_ENGLISH_TYPE_UK);
    //  } else {
    config.setTtsEnglishType(TransAsrConfig.TTS_ENGLISH_TYPE_US);
    // }
//     设置开始识别提示音
    //config.setRecognizeStartAudioRes(R.raw.bdspeech_recognition_start);
    // 重新设置一下config。
    client.setConfig(config);
    // ======================== 配置结束================================

    // 【重要】开始语音识别
    if(to.equals("")!=true) {
      Log.d(TAG, "开始识别");
      client.startRecognize(from, to);
    }
  }

  private void stopRecognize() {
    Log.d(TAG, "语音识别结束");
    // 【重要】停止语音识别（有回调）
    client.stopRecognize();

    // 【重要】取消语音识别（没有回调）
    // client.cancelRecognize();
  }
//  //权限判断和申请
//  private void initPermission() {
//
//    mPermissionList.clear();//清空没有通过的权限
//
//    //逐个判断你要的权限是否已经通过
//    for (int i = 0; i < permissions.length; i++) {
//      if (ContextCompat.checkSelfPermission(this, permissions[i]) != PackageManager.PERMISSION_GRANTED) {
//        mPermissionList.add(permissions[i]);//添加还未授予的权限
//      }
//    }
//
//    //申请权限
//    if (mPermissionList.size() > 0) {//有权限没有通过，需要申请
//      ActivityCompat.requestPermissions(this, permissions, mRequestCode);
//    } else {
//      //说明权限都已经通过，可以做你想做的事情去
//    }
//  }
public static void verifyAudioPermissions(Activity activity) {
  int permission = ActivityCompat.checkSelfPermission(activity,
          Manifest.permission.RECORD_AUDIO);
  if (permission != PackageManager.PERMISSION_GRANTED) {
    ActivityCompat.requestPermissions(activity, PERMISSION_AUDIO,
            GET_RECODE_AUDIO);
  }
}

  public void onResume() {
    super.onResume();
    MobclickAgent.onResume(this);

  }

  public void onPause() {
    super.onPause();
    MobclickAgent.onPause(this);
  }



}

