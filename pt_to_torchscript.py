import ultralytics
from ultralytics import YOLO

models = [
    { 'name': 'yolo11n.pt', 'input': 640 }, 
    { 'name': 'yolo11n-96-in-dim.pt', 'input': 96 }, 
    { 'name': 'yolo11n-160-in-dim.pt', 'input': 160 }, 
    { 'name': 'yolo11n-320-in-dim.pt', 'input': 320 },
]

yolo_model = YOLO('yolo11n.pt')
yolo_model.save(models[1]['name'])
yolo_model.save(models[2]['name'])
yolo_model.save(models[3]['name'])

def convert_to_torchscript(model_info):
    model = YOLO(model_info['name'])
    print('model name :', model.model_name)
    model = model.to("cpu")
    model.eval()
    model.export(format="torchscript", optimize=True, device='cpu', imgsz=model_info['input'])


def convert_to_onnx(model_info):
    model = YOLO(model_info['name'])
    print('model name :', model.model_name)
    model = model.to("cpu")
    model.eval()
    # Try common export options; different ultralytics versions accept different args.
    # We attempt the most-featured call first, then fall back if a TypeError occurs.
    tried = False
    try:
        model.export(format="onnx", optimize=True, simplify=True, device='cpu', imgsz=model_info['input'], opset=16)
        tried = True
    except TypeError:
        pass

    if not tried:
        try:
            model.export(format="onnx", optimize=True, device='cpu', imgsz=model_info['input'], opset=16)
            tried = True
        except TypeError:
            pass

    if not tried:
        # Last-resort: call with minimal args
        model.export(format="onnx", device='cpu', imgsz=model_info['input'], opset=16)

for model in models:
    print('====================================================')
    print(model)
    convert_to_torchscript(model)
    convert_to_onnx(model)
    print('====================================================')
