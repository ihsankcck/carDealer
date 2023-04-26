import formModel from "../model/form-model.js";

export const sendMessage = async (req, res) => {
  const response = await formModel.saveRecord(req.body);

  if (response.id) {
    res.json({
      type: "success",
      message: "Mesajınız Alındı.",
    });
  } else {
    res.json({
      type: "error",
      message: "Mesajınız Gönderilirken bir Hata Oluştu!",
    });
  }
};
